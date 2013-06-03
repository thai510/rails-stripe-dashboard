# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
graph = null

redrawGraph =
  ->
    graph.configure {
      width: $('#chart-container').parent().innerWidth() - 40,
      height: $(window).height() - $('#user_nav').height() - 40
    }
    do graph.update

updateGraph =
    (which)->
        unless which?
            which = $('.active').map (i,e)->$(e).attr('data-value-key')
        $.getJSON '/dashboard/graph_data', {which:which}, (s)->
            pallet = new Rickshaw.Color.Palette()
            series = $.makeArray s
            $.map series, (v,i)->v['color'] = do pallet.color
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
            do graph.render

$(window).resize(redrawGraph)

updateGraph ['churn']
