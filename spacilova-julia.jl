# load packages
using Cascadia
using Gumbo
using Requests
using Plots
using StatsBase

# set basic variables
max_pages = 42            # number of pages
filmnames = []  # array of film names
filmratings = [] # array of film ratings
filmurls = []     # array of film reviews urls

for i = 1:max_pages
    # get every page
    page = get(string("https://kultura.zpravy.idnes.cz/recenze-mirky-spacilove.aspx?strana=",i))
    page_html = parsehtml(convert(String, page.data))
    
    # film names and ratings
    for element in matchall(Selector(".rec-box"),page_html.root)
        push!(filmnames, strip(split(nodeText(element),"%")[2]))
        push!(filmratings, parse(Int,strip(split(nodeText(element),"%")[1])))
    end
    
    # reviews urls
    for element in matchall(Selector(".art > a"),page_html.root)
        push!(filmurls, element.attributes["href"])
    end
    
end

histogram(filmratings, bins=10)

writecsv("reviews.csv", [filmnames filmratings filmurls])

countmap(filmratings)