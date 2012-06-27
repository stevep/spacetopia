Messages = new Meteor.Collection 'messages'

if Meteor.is_client

  postMessage = (event) ->
    name =      document.getElementById("name")
    message =   document.getElementById("messageBox")

    unless message.value == "" or name.value == ""
      Messages.insert(
        name:     name.value 
        message:  message.value 
        time:     Date.now() / 1000
      )

      message.value = ""

  postMessageHandler = (options) ->
    ok = options.ok || ->

    (evt) ->
      if evt.type == "keyup" and evt.which == 13
        ok.call(this, evt)
      else if evt.type == "click" and evt.target.id == "post"
        ok.call(this, evt)

  Template.entry.events = {}
  Template.entry.events['keyup #messageBox, click #post'] = postMessageHandler(
    ok: postMessage
  )

  Template.messages.messages = ->
    Messages.find({}, { sort: {time: -1} })

  Handlebars.registerHelper('formattime', (timestamp, options) ->
    d = new Date(Math.round(timestamp*1000))
    (if (d.getHours()% 24) <= 9 then "0" else "")+(d.getHours() % 24)+":"+(if d.getMinutes() <= 9 then "0" else "")+d.getMinutes()+":"+(if d.getSeconds() <= 9 then "0" else "")+d.getSeconds()
  )
