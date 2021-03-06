{_, ObjectId, mongoose} = app.libs

Notification = mongoose.Schema
  account_id:
    type: ObjectId
    ref: 'Account'

  group_name:
    type: String

  type:
    required: true
    type: String
    enum: ['payment_success', 'ticket_create', 'ticket_reply']

  level:
    required: true
    type: String
    enum: ['notice', 'event', 'log']

  created_at:
    type: Date
    default: Date.now

  payload:
    type: Object

_.extend app.models,
  Notification: mongoose.model 'Notification', Notification
