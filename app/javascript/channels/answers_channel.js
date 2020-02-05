import consumer from "./consumer"

consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
    received(data) {
        var answerJson = JSON.parse(data);
        if (gon.user_id != answerJson['user_id']) {
            var $answerDivId = $('<div class="answer answer-' + answerJson['id'] + '"></div>');
            var $answerCard = $('<div class="card answer-' + answerJson['id'] + '"></div>');
            $('.answers').append($answerDivId);
            $($answerDivId).append($answerCard);
            var $html = $('<div class="card-body"><div class="btn-group"><div class="w-30 p-2"><div class="rating"><div class="rating">'+
                '<div class="circle">0</div> </div> </div> </div> <div class="w-70 p-2">' +
                '<p class="card-text"></p> </div> </div> </div>');
            $($answerCard).append($html);
            $('.answer-' + answerJson['id'] + ' .card-text').text(answerJson['body']);
        }
    }
});
