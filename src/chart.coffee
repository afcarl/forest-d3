chartProperties = [
    ['container'],
    ['autoResize', true]
]

@ForestD3.Chart = class Chart
    constructor: (domContainer)->
        @properties = {}

        for propPair in chartProperties
            [prop, defaultVal] = propPair
            @properties[prop] = defaultVal

            @[prop] = do (prop)=>
                (d)=>
                    unless d?
                        return @properties[prop]
                        
                    else
                        @properties[prop] = d 
                        return @


        @container domContainer
        @svg = @createSvg()

        ###
        Auto resize the chart if user resizes the browser window.
        ###
        window.onresize = =>
            if @autoResize()
                @render()

    render: ->
        return @ unless @chartData?
        @calcDimensions()
        @updateChartFrame()

        @

    data: (d)->
        @chartData = d
        @

    calcDimensions: ->
        container = @container()
        if container?
            bounds = container.getBoundingClientRect()

            @height = bounds.height
            @width = bounds.width

            @margin = 
                left: 80
                bottom: 40
                right: 0
                top: 0

            @canvasHeight = @height - @margin.bottom
            @canvasWidth = @width - @margin.left

    createSvg: ->
        container = @container()
        if container?
            exists = d3.select(container)
            .classed('forest-d3',true)
            .select 'svg'
            if exists.empty()
                return d3.select(container).append('svg')
            else
                return exists 

        return null

    updateChartFrame: ->
        backdrop = @svg.selectAll('rect.backdrop').data([0])
        backdrop.enter()
            .append('rect')
            .classed('backdrop', true)
        backdrop
            .attr('width', @width)
            .attr('height', @height)
 
        canvas = @svg.selectAll('g.canvas').data([0])

        canvas.enter().append('g')
            .classed('canvas', true)
            .attr('transform',"translate(#{@margin.left}, 0)")
            .append('rect')
            .classed('canvas-backdrop', true)

        canvas.select('rect.canvas-backdrop')
            .attr('width', @width - @margin.left)
            .attr('height', @height - @margin.bottom)
     