ElmFormatView = require './elm-format-view'
{CompositeDisposable} = require 'atom'

module.exports = ElmFormat =
  elmFormatView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @elmFormatView = new ElmFormatView(state.elmFormatViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @elmFormatView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'elm-format:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @elmFormatView.destroy()

  serialize: ->
    elmFormatViewState: @elmFormatView.serialize()

  toggle: ->
    console.log 'ElmFormat was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
