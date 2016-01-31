chart = new ForestD3.Chart d3.select('#example')
legend = new ForestD3.Legend d3.select('#legend')

chart
    .ordinal(true)
    .margin({left: 90})
    .xPadding(0)
    .xLabel('Date')
    .yLabel('Price')
    .yTickFormat(d3.format(',.2f'))
    .xTickFormat((d)->
        if d?
            d3.time.format('%Y-%m-%d')(new Date d)
        else
            ''
    )
    .addPlugin(legend)

getStocks = (startPrice, volatility, points=80)->
    result = []
    startDate = new Date 2012, 0, 1

    for i in [0...points]
        result.push [
            startDate.getTime(),
            startPrice - 0.3
        ]
        changePct = 2 * volatility * Math.random()
        if changePct > volatility
            changePct -= 2*volatility

        startPrice += startPrice * changePct
        startDate.setDate(startDate.getDate()+1)

    result

data = [
    key: 'series1'
    label: 'AAPL'
    type: 'line'
    interpolate: 'cardinal'
    values: getStocks(5.75, 0.47)
,
    key: 'series2'
    label: 'MSFT'
    type: 'line'
    area: true
    values: getStocks(5, 1.1)
,
    key: 'series3'
    label: 'FACEBOOK'
    type: 'line'
    area: true
    interpolate: 'cardinal'
    values: getStocks(6.56, 0.13)
,
    key: 'series4'
    label: 'AMAZON'
    type: 'line'
    area: false
    values: getStocks(7.89, 0.37)
,
    key: 'marker1'
    label: 'Profit'
    type: 'marker'
    axis: 'y'
    value: 0.2
,
    key: 'region1'
    label: 'Earnings Season'
    type: 'region'
    axis: 'x'
    values: [5, 9]
]

chart.data(data).render()

# ******************** Update Data Example *********************
chartUpdate = new ForestD3.Chart '#example-update'

chartUpdate
    .ordinal(true)
    .chartLabel('Citi Bank (NYSE)')
    .xTickFormat((d)->
        if d?
            d3.time.format('%Y-%m-%d')(new Date d)
        else
            ''
    )

dataUpdate = [
    key: 'series1'
    type: 'line'
    label: 'CITI'
    values: getStocks(206, 0.07, 200)
]

chartUpdate.data(dataUpdate).render()

document.getElementById('update-data').addEventListener 'click', ->
    dataUpdate[0].values = getStocks(206, 0.07, 200)
    chartUpdate
        .data(dataUpdate)
        .render()

# ******************* Log Scale Chart Example *******************
chartLog = new ForestD3.Chart '#example-log-scale'
chartLog
    .ordinal(true)
    .yScaleType(d3.scale.log)
    .yPadding(0)
    .chartLabel('Logarithmic Scale Example')
    .tooltipType('spatial')
    .xTickFormat((d)->
        if d?
            d3.time.format('%Y-%m')(new Date d)
        else
            ''
    )

dataLog = [
    key: 'series1'
    label: 'AAPL'
    type: 'line'
    color: '#efefef'
    values: getStocks(200, 0.4, 100).map (p)->
        if p[1] <= 0
            p[1] = 1

        p
]

chartLog.data(dataLog).render()

# ****************** Randomized data points and auto sort ***********
chartRandom = new ForestD3.Chart '#example-random'
chartRandom
    .ordinal(false)
    .getX((d)-> d.x)
    .getY((d)-> d.y)
    .chartLabel('Random Data Points')

getRandom = ->
    rand = d3.random.normal(0, 0.6)
    points = [0...50].map (i)->
        x: i
        y: rand()

    d3.shuffle points

dataRandom =
    series1:
        type: 'line'
        values: getRandom()
    series2:
        type: 'line'
        values: getRandom()

chartRandom.data(dataRandom).render()

# ********************** Non Ordinal Line and scatter **************
chartNonOrdinal = new ForestD3.Chart '#example-non-ordinal'
chartNonOrdinal
    .ordinal(false)
    .tooltipType('spatial')
    .xTickFormat(d3.format('.2f'))
    .chartLabel('Non-Ordinal Chart')

rand = d3.random.normal(0, 0.6)
dataNonOrdinal = [
    type: 'scatter'
    symbol: 'circle'
    color: 'yellow'
    values: [0..20].map (d)-> [rand(), rand()]
,
    type: 'line'
    color: 'white'
    values: [
        [-1, -1]
        [-0.8, -0.7]
        [-0.3, -0.56]
        [0.4, 0.7]
        [0.2, 0.5]
        [0.5, 0.8]
        [1, 1.1]
    ]
]

chartNonOrdinal.data(dataNonOrdinal).render()

document.getElementById('update-x-sort').addEventListener 'click', ->
    chartRandom.autoSortXValues(not chartRandom.autoSortXValues())
    chartRandom.data(dataRandom).render()

# ********************* Switching series type example ***************
chartSwitcher = new ForestD3.Chart '#example-type-switch'
chartSwitcher
    .xTickFormat((d)->
        if d?
            d3.time.format('%Y-%m-%d')(new Date d)
        else
            ''
    )

switchData =
    series:
        color: 'springgreen'
        type: 'line'
        values: getStocks(345,0.2)

chartSwitcher.data(switchData).render()

document.getElementById('switch-to-line').addEventListener 'click', ->
    switchData.series.type = 'line'
    switchData.series.area = false
    chartSwitcher.data(switchData).render()

document.getElementById('switch-to-scatter').addEventListener 'click', ->
    switchData.series.type = 'scatter'
    chartSwitcher.data(switchData).render()

document.getElementById('switch-to-bar').addEventListener 'click', ->
    switchData.series.type = 'bar'
    chartSwitcher.data(switchData).render()

document.getElementById('switch-to-area').addEventListener 'click', ->
    switchData.series.type = 'line'
    switchData.series.area = true
    chartSwitcher.data(switchData).render()