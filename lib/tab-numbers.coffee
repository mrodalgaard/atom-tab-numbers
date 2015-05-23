TabNumbersView = require './tab-numbers-view'

module.exports = TabNumbers =
  config:
    showNumberOfOpenTabs:
      type: 'boolean'
      default: true

  activate: ->

  deactivate: ->
    @tabNumbersView?.destroy()
    @statusBarTile?.destroy()
    @statusBarTile = null

  consumeStatusBar: (statusBar) ->
    if atom.config.get('tab-numbers.showNumberOfOpenTabs')
      @tabNumbersView ?= new TabNumbersView()
      @statusBarTile = statusBar.addLeftTile(item: @tabNumbersView, priority: 200)
