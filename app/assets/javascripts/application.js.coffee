# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require_tree .

$(document).on "page:change", ->
  $(".tabs").tabs()

$(document).on "ready page:load", ->
  $("input[role='tags']").tagEditor
    onChange: (field, editor, tags) ->
      $(field).val(tags.join(","))
  hideFlashes = ->
    $(".flash").each ->
      $("div", this).slideUp()
      $(this).on "click", =>
        $(this).remove()
      $(this).on "mouseover", =>
        $("div", this).slideDown()
  window.setTimeout hideFlashes, 1000
