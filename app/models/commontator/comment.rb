module Commontator
  class Comment < ActiveRecord::Base
    belongs_to :creator, :polymorphic => true
    belongs_to :editor, :polymorphic => true
    belongs_to :thread

    has_one :commontable, :through => :thread

    validates_presence_of :creator, :on => :create
    validates_presence_of :editor, :on => :update
    validates_presence_of :thread
    validates_presence_of :body

    validates_uniqueness_of :body, :scope => [:creator_type, :creator_id, :thread_id],
                            :message => 'has already been posted'

    protected

    cattr_accessor :acts_as_votable_initialized

    public

    def is_votable?
      return true if acts_as_votable_initialized
      return false unless self.class.respond_to?(:acts_as_votable)
      self.class.acts_as_votable
      self.class.acts_as_votable_initialized = true
    end

    def get_vote_by(user)
      return nil unless is_votable?
      votes.where(:voter_type => user.class.name, :voter_id => user.id).first
    end

    def is_modified?
      !editor.nil?
    end

    def is_deleted?
      !deleted_at.blank?
    end

    def delete_by(user)
      return false if is_deleted?
      self.deleted_at = Time.now
      self.editor = user
      self.save
    end

    def undelete_by(user)
      return false unless is_deleted?
      self.deleted_at = nil
      self.editor = user
      self.save
    end

    def timestamp
      config = thread.config
      "#{config.comment_create_verb_past.capitalize} em " + \
        created_at.strftime(config.timestamp_format) + \
        (is_modified? ? " | #{config.comment_edit_verb_past} em " + \
          updated_at.strftime(config.timestamp_format) : '')
    end

    ##################
    # Access Control #
    ##################

    def can_be_read_by?(user)
      (thread.can_be_read_by?(user) && \
        (!is_deleted? || thread.config.deleted_comments_are_visible)) ||\
        thread.can_be_edited_by?(user)
    end

    def can_be_created_by?(user)
      !thread.is_closed? && thread.can_be_read_by?(user) && user == creator
    end

    def can_be_edited_by?(user)
      !thread.is_closed? && !is_deleted? &&\
        ((user == creator && thread.config.can_edit_own_comments && thread.can_be_read_by?(user)) ||\
        (thread.can_be_edited_by?(user) && thread.config.admin_can_edit_comments)) &&\
        (thread.comments.last == self || thread.config.can_edit_old_comments)
    end

    def can_be_deleted_by?(user)
      (!thread.is_closed? &&\
        ((user == creator && thread.config.can_delete_own_comments && \
        thread.can_be_read_by?(user) && (!is_deleted? || editor == user)) &&\
        (thread.comments.last == self || thread.config.can_delete_old_comments))) ||\
        thread.can_be_edited_by?(user)
    end

    def can_be_voted_on?
      !thread.is_closed? && is_votable? && !is_deleted? && thread.config.can_vote_on_comments
    end

    def can_be_voted_on_by?(user)
      can_be_voted_on? && thread.can_be_read_by?(user) && user != creator
    end
  end
end
