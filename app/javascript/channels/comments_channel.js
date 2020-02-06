import consumer from "./consumer"

consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    received(data) {
        var commentJson = JSON.parse(data);
        if (gon.user_id === commentJson['user_id']) return;

        var commentableId = '.' + commentJson['commentable_type'].toLowerCase() + '-' + commentJson['commentable_id'];
        $(commentableId + ' .comments ul').append('<li class="list-group-item text-right">' + commentJson['body'] + '</li>');
    }
});
