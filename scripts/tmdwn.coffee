
module.exports = (robot) ->
  #from http://stackoverflow.com/a/2527974
  dateRegex = "countdown to (.*?) at " +  #Event
    "("                      +  # start of date
        "201[0-9]"           +  # year: 2010, 2011, ..., through 2019
        "\\W"                +  # delimiter between year and month; typically will be "-"
        "([0]?[0-9]|1[012])" +  # month: 0 through 9, or 00 through 09, or 10 through 12
        "\\W"                +  # delimiter between month and day; typically will be "-"
        "([012]?[0-9]|3[01])"+  # day: 0 through 9, or 00 through 29, or 30, or 31
    ")?"                     +  # end of optional date
    "\\s?"                   +  # optional whitespace
    "("                      +  # start of time
        "([01]?[0-9]|2[0-3])"+  # hour: 0 through 9, or 00 through 19, or 20 through 23
        "\\W"                +  # delimiter between hours and minutes; typically will be ":"
        "([0-5][0-9])"       +  # minute: 00 through 59
        "("                  +  # start of seconds (optional)
            "\\W"            +  # delimiter between minutes and seconds; typically will be ":"
            "([0-5][0-9])"   +  # seconds: 00 through 59
        ")?"                 +  # end of optional seconds
        "(\\s*[AaPp][Mm])?"  +  # optional AM, am, PM, pm
    ")?"                     +  # end of optional time
    "$";

  robot.respond (new RegExp(dateRegex, "i")), (msg)->
    event = msg.match[1]
    date = msg.match[2]
    time = msg.match[5]
    ampm = msg.match[10]
    if(parseInt(msg.match[6]) > 12)
      ampm = "PM"
    if(ampm == null)
      msg.send "Oop! I can't figure out that time, try again with AM/PM"
    else
      msg.send("one sec...")
      msg.http("http://tmdwn.com")
        .header('Content-Type', 'application/json')
        .post(JSON.stringify({
          authenticity_token: "fr3H3GZfz1L700t6XIY5En7jL8efTT6rrfEovflxxs4=",
          tmdwn: {
            date: date,
            time: time + ampm,
            title: event
          }
        })) (err, res, body) ->
          console.log(err)
          console.log(res)
          console.log(JSON.stringify(body))

    console.log(JSON.stringify(msg.match))

    #["hubot countdown to foo at 2014-08-09 12:34:55",
    #1:  "foo",
    #2:  "2014-08-09",
    #3:  "08",
    #4:  "09",
    #5:  "12:34:55",
    #6:  "12",
    #7:  "34",
    #8:  ":55",
    #9:  "55",
    #10: null]
