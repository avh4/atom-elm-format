{BufferedProcess} = require('atom')
fs = require('fs')
temp = require("temp").track()

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace',
      'elm:format': => @fmt()

  isValidEditor: (editor) ->
    editor?.getGrammar()?.scopeName is 'source.go'

    # add save hooks
  #   atom.project.eachEditor (editor) =>
  #     @addSaveHook(editor)
  #
  #   atom.subscribe atom.project, 'editor-created', (editor) =>
  #     @addSaveHook(editor)
  #
  # addSaveHook: (editor) ->
  #   atom.subscribe editor.getBuffer(), 'will-be-saved', => @fmt()

  # formatCurrentBuffer: ->
  #   editor = atom?.workspace?.getActiveTextEditor()
  #   return unless @dispatch.isValidEditor(editor)
  #   done = (err, messages) =>
  #     @dispatch.resetAndDisplayMessages(editor, messages)
  #   @formatBuffer(editor, false, done)
  #
  # formatBuffer: (editor, saving, callback = -> ) ->
  #   unless @dispatch.isValidEditor(editor)
  #     @emit(@name + '-complete', editor, saving)
  #     callback(null)
  #     return
  #   if saving and not atom.config.get('go-plus.formatOnSave')
  #     @emit(@name + '-complete', editor, saving)
  #     callback(null)
  #     return
  #   buffer = editor?.getBuffer()
  #   unless buffer?
  #     @emit(@name + '-complete', editor, saving)
  #     callback(null)
  #     return
  #   cwd = path.dirname(buffer.getPath())
  #   args = ['-w']
  #   configArgs = @dispatch.splicersplitter.splitAndSquashToArray(' ', atom.config.get('go-plus.formatArgs'))
  #   args = _.union(args, configArgs) if configArgs? and _.size(configArgs) > 0
  #   args = _.union(args, [buffer.getPath()])
  #   go = @dispatch.goexecutable.current()
  #   unless go?
  #     callback(null)
  #     @dispatch.displayGoInfo(false)
  #     return
  #   gopath = go.buildgopath()
  #   if not gopath? or gopath is ''
  #     @emit(@name + '-complete', editor, saving)
  #     callback(null)
  #     return
  #   env = @dispatch.env()
  #   env['GOPATH'] = gopath
  #   cmd = go.format()
  #   if cmd is false
  #     message =
  #       line: false
  #       column: false
  #       msg: 'Format Tool Missing'
  #       type: 'error'
  #       source: @name
  #     callback(null, [message])
  #     return
  #
  #   {stdout, stderr, messages} = @dispatch.executor.execSync(cmd, cwd, env, args)
  #
  #   console.log(@name + ' - stdout: ' + stdout) if stdout? and stdout.trim() isnt ''
  #   messages = @mapMessages(stderr, cwd) if stderr? and stderr.trim() isnt ''
  #   @emit(@name + '-complete', editor, saving)
  #   callback(null, messages)

  fmt: ->
    editor = atom?.workspace?.getActiveTextEditor()
    # Only process .elm files.
    # return unless /\.elm$/.exec(editor.getUri())
    # return unless @isValidEditor(editor)

    buffer = editor?.getBuffer()
    path = buffer.getPath()

    # code = editor.getText()

    # temp.open ".elm-format", (err, info) ->
    #   fs.write(info.fd, code)
    #   fs.close(info.fd, ->)
    args = ["--yes", path]
    fail = false

    stdout = (output) ->
      console.log("Output running elm-format: " + output)
      # return if fail
      # editor.setText(output)

    stderr = (output) ->
      console.log("Error running elm-format: " + output)
      fail = true

    command = "/usr/local/bin/elm-format"
    new BufferedProcess({command, args, stdout, stderr})
