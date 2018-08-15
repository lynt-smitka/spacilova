# load packages
import pandas as pd
import requests
import re
from bs4 import BeautifulSoup


# set basic variables
max_pages = 42            # number of pages
filmnames = pd.Series()   # vector of film names
filmratings = pd.Series() # vector of film ratings
filmurl = pd.Series()     # vector of film reviews urls

# go to web and get all 42 pages with links to reviews
for i in range(max_pages): #R from 1, Python from 0 = i+1
    # get every page
    page = "https://kultura.zpravy.idnes.cz/recenze-mirky-spacilove.aspx?strana=%d" % (i+1)
    page_html = BeautifulSoup(requests.get(page).text, "html.parser")
    # film names

    # ......... find names of films
    
    tmp_filmnames = pd.Series(page_html.select(".rec-box")) \
    .apply(lambda f: f.getText().strip()) \
    .apply(lambda f: re.sub("\d{1,3}\s%\s","",f))
    # another option without regexp
    #.apply(lambda f: f.split("%",1)[1].strip())
    
    #another option with common python list   
    #tmp_filmnames = page_html.select(".rec-box")
    #tmp_filmnames = [f.getText().strip() for f in tmp_filmnames]
    #tmp_filmnames = [f.split("%",1)[1].strip() for f in tmp_filmnames]
    
    # film ratings

    # ......... find film ratings
    tmp_filmratings = pd.Series(page_html.select(".rating")) \
    .apply(lambda f: f.getText().strip())
    
    # ......... and make them numeric
    tmp_filmratings = tmp_filmratings.apply(lambda f: int(re.sub("\s%","",f)))
    # another option without regexp
    #tmp_filmratings = tmp_filmratings.apply(lambda f: int(f.strip("%")))
    
    # film reviews url
    tmp_filmurl = pd.Series(page_html.select(".art > a")) \
    .apply(lambda f: f.attrs["href"])
    
    # save the results
    filmnames = filmnames.append(tmp_filmnames)
    filmratings = filmratings.append(tmp_filmratings)
    filmurl = filmurl.append(tmp_filmurl)

    # print some info
    print("Page ready:", i+1)

# make data frame
reviews = pd.DataFrame({
    "film": filmnames,
    "rating": filmratings,
    "url": filmurl
    })

# create basic histogram
reviews.plot.hist()

#write CSV
reviews.to_csv("reviews.csv", index=False, encoding="utf-8")

## reviews.rating.value_counts(sort=False)

## reviews.describe()