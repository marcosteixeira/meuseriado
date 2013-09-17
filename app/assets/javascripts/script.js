function pesquisarSeries() {

    $.ajax({
        url: "/series/carregar_series",
        success: function (data) {

            $(data.series).each(function (i, serie) {

                if (jQuery("#" + serie.id).length == 0) {

                    $("#lista-dos-resultados").append('<li>');
                    $("#lista-dos-resultados").find('li:last').attr('id', serie.id);
                    $("#lista-dos-resultados").find('li:last').append('<div>');
                    $("#lista-dos-resultados").find('div:last').addClass('large-3 columns');
                    $("#lista-dos-resultados").find('div:last').append('<div>');
                    $("#lista-dos-resultados").find('div:last').addClass('miniatura-resultados');
                    $("#lista-dos-resultados").find('div:last').append('<a>');
                    $("#lista-dos-resultados").find('div:last').find('a').attr("href", "/series/"+serie.slug);
                    $("#lista-dos-resultados").find('a:last').append('<img>');
                    $("#lista-dos-resultados").find('div:last').find('img').addClass("foto-serie-pesquisada");
                    $("#lista-dos-resultados").find('div:last').find('img').attr("src", serie.poster);
                    $("#lista-dos-resultados").find('div:last').append('<div>');
                    $("#lista-dos-resultados").find('div:last').addClass('descricao-item-listado');
                    $("#lista-dos-resultados").find('div:last').append('<a>');
                    $("#lista-dos-resultados").find('div:last').find('a').attr("href", "/series/"+serie.slug);
                    $("#lista-dos-resultados").find('a:last').append('<h3>');
                    $("#lista-dos-resultados").find('div:last').find('h3').append(serie.nome);

                    if(serie.nota){
                        $("#lista-dos-resultados").find('div:last').append('<div>');
                        $("#lista-dos-resultados").find('div:last').attr('id', "star-"+serie.id);
                        $("#lista-dos-resultados").find('div:last').append('<span>')
                        $("#lista-dos-resultados").find('div:last').find('span').addClass('right');
                        $("#lista-dos-resultados").find('div:last').find('span').append(serie.nota);
                        $('#star-'+serie.id).raty({ readOnly: true, score: serie.nota / 2 });
                    }
                }
            });

            habilitaHoverMiniatura();
        }
    });
}
