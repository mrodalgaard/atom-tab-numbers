describe 'Tab Numbers', ->
  {workspaceElement, prevHeight, prevWidth} = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)
    [prevHeight, prevWidth] = atom.getCurrentWindow().getContentSize()
    atom.getCurrentWindow().setContentSize(1500, 1500)

    waitsForPromise ->
      atom.packages.activatePackage 'tab-numbers'

  afterEach ->
    atom.getCurrentWindow().setContentSize(prevHeight, prevWidth)

  describe 'tab style layout', ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage 'tabs'
        atom.workspace.open 'sample1.txt'
        atom.workspace.open 'sample2.txt'

    it 'shows numbers on tabs', ->
      tabsIcons = workspaceElement.querySelectorAll '.pane .tab .close-icon'

      expect(workspaceElement.querySelectorAll('.pane > .tab-bar').length).toBe 4
      expect(getComputedStyle(tabsIcons[0], ':before').content).toBe '\"1\"'
      expect(getComputedStyle(tabsIcons[1], ':before').content).toBe '\"2\"'

    it 'hides number on focus', ->
      tabsIcon = workspaceElement.querySelector '.pane .tab .close-icon'
      expect(getComputedStyle(tabsIcon, ':before').content).toBe '\"1\"'

      workspaceElement.querySelector('.pane .tab').classList.add 'hover'

      expect(getComputedStyle(tabsIcon, ':before').content).not.toBe '\"1\"'

describe 'Tab Counter', ->
  workspaceElement = null

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage 'tab-numbers'
      atom.packages.activatePackage 'status-bar'

  describe 'total tabs count', ->
    it 'shows number of open tabs in status bar', ->
      tabsCount = workspaceElement.querySelector '.status-bar .tab-numbers .tabs-count'

      expect(tabsCount.innerHTML).toBe '0'

      waitsForPromise ->
        atom.workspace.open 'sample1.txt'
        atom.workspace.open 'sample2.txt'
      runs ->
        expect(tabsCount.innerHTML).toBe '2'

    it 'removes total tabs count with config', ->
      tabsElement = workspaceElement.querySelector '.status-bar .tab-numbers'
      expect(tabsElement).not.toBe null

      atom.config.set('tab-numbers.showNumberOfOpenTabs', false)
      tabsElement = workspaceElement.querySelector '.status-bar .tab-numbers'
      expect(tabsElement).toBe null
