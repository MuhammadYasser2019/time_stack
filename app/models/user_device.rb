class UserDevice < ApplicationRecord
    has_one :user

    def self.send_shift_notification
        # GET ALL USER whose shift is starting or ending. If the user have not filled their time entry then fetch their token from the database and finally generate a message to send to the users. Make sure not to send the notification twice for the same entry. 

        messages = [{
            to: "ExponentPushToken[dcZ4lePXiZATqWRqPfkjNO]",
            sound: "default",
            body: "Hello world!"
          }, {
            to: "ExponentPushToken[dcZ4lePXiZATqWRqPfkjNO]",
            badge: 1,
            body: "You've got mail"
          }]

        handle_push_notifications(messages)
    end

    private 

    def self.handle_push_notifications(messages)  
        # MAX 100 messages at a time     
        messages.each_slice(100){|message| send_push_notification(message)}
    end

    def self.send_push_notification(messages)
        client = Exponent::Push::Client.new
       
        # MAX 100 messages at a time
        handler = client.send_messages(messages)

        # Array of all errors returned from the API
        puts handler.errors

        # you probably want to delay calling this because the service might take a few moments to send
        client.verify_deliveries(handler.receipt_ids)
    end
end
  