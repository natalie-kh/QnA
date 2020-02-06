$(document).on('turbolinks:load', function(){
    $('.rating').on('ajax:success', function(e) {
        var votable = e.detail[0];
        var votable_css = '.'+ votable["votable_type"].toLowerCase() + '-' + votable["votable_id"] + ' .rating .circle';
        $(votable_css).text(votable["votes"]);
    })
});
