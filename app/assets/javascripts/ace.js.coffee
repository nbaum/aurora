jQuery.fn.extend
  ace: ->
    @each ->
      input = $(this)
      input.hide()
      mode = input.data("ace-mode")
      div = $("<div>").insertBefore(input)
      div.css("flex-grow": "1", "height": "30em")
      window.aceEditor = aceEditor = ace.edit(div[0])
      aceEditor.setTheme("ace/theme/chrome")
      aceEditor.setOptions
        fontFamily: "Roboto Mono"
        fontSize: "12pt"
      aceEditor.getSession().setMode("ace/mode/#{mode}")
      aceEditor.getSession().setUseWrapMode(true)
      aceEditor.getSession().setTabSize(2)
      aceEditor.getSession().setValue(input.val())
      aceEditor.getSession().on 'change', ->
        input.val(aceEditor.getSession().getValue())

$(document).on "ready page:load", ->
  $("[data-ace-mode]").ace()
