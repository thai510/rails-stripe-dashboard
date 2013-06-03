# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateGraph =
    (which)->
        unless which?
            which = $('.active').map (i,e)->$(e).attr('data-value-key')
        $.getJSON '/dashboard/graph_data', {which:which}, (series)->
            pallet = new Rickshaw.Color.Palette()
            series = $.makeArray series
            $.map series, (v,i)->v['color'] = do pallet.color
            console.log series
            graph = new Rickshaw.Graph {
                element: $('#chart')[0],
                width: 600,
                height: 575,
                renderer: 'line',
                series: series
            }
            x_axis = new Rickshaw.Graph.Axis.Time { graph: graph }
            do graph.render

updateGraph ['churn']
