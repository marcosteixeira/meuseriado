function pesquisarSeries() {

    $.ajax({
        url: "/series/carregar_series",
        success: function (data) {

            $(data.series).each(function (i, serie) {

                if (jQuery("#" + serie.id).length == 0) {

                    $("#lista-dos-resultados").append('<li>');
                    $("#lista-dos-resultados").append('<div>');
                    $("#lista-dos-resultados").find('div:last').addClass('miniatura-resultados');
                    $("#lista-dos-resultados").find('div:last').attr('onclick', "window.location='/series/" + serie.slug + "'");
                    $("#lista-dos-resultados").find('div:last').append('<img>');
                    $("#lista-dos-resultados").find('div:last').find('img').addClass("foto-serie-pesquisada");
                    $("#lista-dos-resultados").find('div:last').find('img').attr("src", serie.poster);
                    $("#lista-dos-resultados").find('div:last').append('<div>');
                    $("#lista-dos-resultados").find('div:last').addClass('descricao-item-listado');
                    $("#lista-dos-resultados").find('div:last').append('<h3>');
                    $("#lista-dos-resultados").find('div:last').find('<h3>').append(serie.nome);

                }
            });
        }
    });
}
