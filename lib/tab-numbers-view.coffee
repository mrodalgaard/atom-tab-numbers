{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

module.exports =
class TabNumbersView extends View
  nTabs: 0

  @content: ->
    @div class: 'tab-numbers inline-block', tabindex: -1, =>
      @div outlet: 'tabNumbers', =>
        @span class: 'icon icon-versions'
        @span class: 'tabs-count', outlet: 'tabCount', '0'

  initialize: ->
    @subscriptions = new CompositeDisposable

    for pane in atom.workspace.getPanes()
      @nTabs += pane.getItems().length
    @update(0)

    @subscriptions.add atom.workspace.onDidAddPaneItem (event) =>
      @update(1)

    @subscriptions.add atom.workspace.onDidDestroyPaneItem (event) =>
      @update(-1)

  destroy: ->
    @subscriptions.dispose()
    @detach()

  update: (n) ->
    @nTabs += n

    @tabNumbers.toggleClass('text-warning', @nTabs >= 5 && @nTabs < 10)
    @tabNumbers.toggleClass('text-error', @nTabs >= 10)

    @tabCount.text(@nTabs)
    @toolTipDisposable?.dispose()
    @toolTipDisposable = atom.tooltips.add @element, title: "#{@nTabs} open tabs"
