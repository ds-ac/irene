`import Ember from 'ember'`
`import Notify from 'ember-notify';`
`import cookieUtil from '../utils/cookies';`
`import ENUMS from '../enums';`

SocketMixin = Ember.Mixin.create
  sockets:
    connect: ->
      @socket.emit "subscribe", room: @session.get("user").uuid
      console.log "Socket is connected!"

    disconnect: ->
      console.log "Socket got disconnected!"

    analysis_updated: (data)->
      Notify.info "Analysis updated"
      @store.push "analysis", @store.normalize "analysis", data

    file_new: (data)->
      Notify.info "New file added"
      file = @store.normalize "file", data
      file.get "analyses"
      @store.push "file", file
      @store
        .find 'project', data.project
        .then (project) ->
          project.set "lastFile", file

    project_new: (data) ->
      Notify.info "New project added"
      @store.push "project", @store.normalize "project", data

    message: (data) ->
      message = data.message
      notifyType = data.notifyType
      Notify.info message if notifyType is ENUMS.NOTIFY.INFO
      Notify.success message if notifyType is ENUMS.NOTIFY.SUCCESS
      Notify.warning message if notifyType is ENUMS.NOTIFY.WARNING
      Notify.alert message if notifyType is ENUMS.NOTIFY.ALERT
      Notify.error message if notifyType is ENUMS.NOTIFY.ERROR


    logout: ->
      cookieUtil.deleteAllCookies()
      localStorage.clear()
      location.reload()

    reload: ->
      location.reload()

`export default SocketMixin`
