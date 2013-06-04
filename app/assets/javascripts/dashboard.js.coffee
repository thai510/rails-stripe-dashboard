# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
graph = null

updateNavHeaders =
  ->
    $('.nav-header').each (i,v)->
      $(v).toggleClass 'active', $(v).nextUntil('.nav-header').hasClass('active')

redrawGraph =
  ->
    if graph?
      graph.configure {
        width: $('#chart-container').parent().innerWidth() - 40,
        height: $(window).height() - $('#user_nav').height() - 40
      }
      do graph.update

updateGraph =
  (which = $.makeArray $('.active').map (i,e)->$(e).attr('data-value-key'))->
    $('[data-value-key]>a').css('background-color','')
    $('#chart-container').empty()
    if which? and which.length > 0
      $('#chart-container').append $('<div>').attr('id', id) for id in [ 'y-axis', 'chart' ]
      $.getJSON '/dashboard/graph_data', {which:which}, (s)->
        pallet = new Rickshaw.Color.Palette()
        series = $.makeArray s
        $.map series, (v,i)->v['color'] = do pallet.color
        $.each series, (i,v)->
          $('[data-value-key="'+v.name+'"]>a').css('background-color',v.color)
        graph = new Rickshaw.Graph {
          element: $('#chart')[0],
          width: $('#chart-container').parent().innerWidth() - 40,
          height: $(window).height() - $('#user_nav').height() - 40,
          renderer: 'line',
          series: series
        }
        time = new Rickshaw.Fixtures.Time()
        days = time.unit('days')
        x_axis = new Rickshaw.Graph.Axis.Time {
          graph: graph,
          timeUnit: days
        }
        y_axis = new Rickshaw.Graph.Axis.Y {
          graph: graph,
          orientation: 'left',
          tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
          element: $('#y-axis')[0]
        }
        hover_detail = new Rickshaw.Graph.HoverDetail {
          graph: graph,
          formatter: (s, x, y)->
            date = '<span class="date">' + new Date(x * 1000).toUTCString() + '</span>'
            swatch = '<span class="detail_swatch" style="background-color: ' + s.color + '"></span>'
            swatch + s.name + ': ' + parseInt(y) + '<br/>' + date
        }
        do graph.render
    else
      graph = null
      $('#chart-container').text("Select one or more category to view graph.")

$(window).resize(redrawGraph)

$(document).delegate '[data-value-key]', 'click', ->
  $(this).toggleClass 'active'
  do updateNavHeaders
  do updateGraph

$(document).delegate 'li.nav-header', 'click', ->
  $(this).toggleClass 'active'
  $(this).nextUntil('.nav-header').toggleClass 'active', $(this).hasClass 'active'
  do updateGraph

$(document).ready ->
  do updateGraph
  do updateNavHeaders

# vim: sw=2 ts=2
