from splinter import Browser
from bs4 import BeautifulSoup as bs
import time
import pandas as pd

def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    executable_path = {"executable_path": "chromedriver"}
    return Browser("chrome", **executable_path, headless=False)


def scrape_info():
    browser = init_browser()

    # mars latest news

    mars_news_url = 'https://mars.nasa.gov/news'
    browser.visit(mars_news_url)
    html = browser.html
    soup = bs(html, 'html.parser')
    mars_headline = soup.find('div', class_='content_title')
    mars_news = soup.find('div', class_='rollover_description_inner').text

    # mars featured image

    mars_images_url = 'https://www.jpl.nasa.gov'
    browser.visit(f'{mars_images_url}/spaceimages/?search=&category=Mars')
    html = browser.html
    soup = bs(html, 'html.parser')
    
    featured_image = soup.find('article', class_='carousel_item')
    featured_style = featured_image['style']
    words=[]
    words=featured_style.split("'")
    featured_image_url= mars_images_url+words[1]

    # mars latest weather data

    mars_weather_url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(mars_weather_url)
    html = browser.html
    soup = bs(html, 'html.parser')
    mars_weather_text = soup.find('div', class_='js-tweet-text-container')
    mars_weather = mars_weather_text.p.text
    mars_w = mars_weather.split('pic.twitter.com')
    mars_weather_data= mars_w[0]

    
    # mars facts table

    mars_facts_url= 'http://space-facts.com/mars/'
    tables = pd.read_html(mars_facts_url)

    mars_facts_df = tables[0]
    mars_facts_df.columns = ['Description', 'Value']
    mars_facts_df
    mars_facts_df.set_index('Description', inplace=True)
    mars_facts_df
    mars_facts_html_table = mars_facts_df.to_html()
    mars_facts_html_table
    mars_facts_table = mars_facts_html_table.replace('\n', '')


    # mars enhanced hemispheres photos

    mars_hem_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    usgs_url = 'https://astrogeology.usgs.gov'
    browser.visit(mars_hem_url)
    html = browser.html
    soup = bs(html, 'html.parser')

    hem_img =[]
    hem_img = soup.find_all('div', class_='description')

    #   browser.click_link_by_partial_text(text)

    hem_dict={}
    hem_list=[]

    for i in range(len(hem_img)):
        for link in hem_img[i].find_all('a'):
            h3_text = hem_img[i].h3.text
            h3_title = h3_text.split(' Enhanced')
            browser.click_link_by_partial_text(h3_text)
            hem_url = browser.find_link_by_partial_href('download')['href']
            hem_dict = {'title': h3_title[0], 'img_url': hem_url}
            hem_list.append(hem_dict)
            browser.visit(mars_hem_url)
        
    # format return data    
    mars_data_dict={}
    mars_data_dict.update({"mars_news_hdline":mars_headline.a.text})
    mars_data_dict.update({"mars_news": mars_news})
    mars_data_dict.update({"mars_featured_image":featured_image_url})
    mars_data_dict.update({"mars_weather":mars_weather_data})
    mars_data_dict.update({"mars_facts":mars_facts_table})
    mars_data_dict.update({"mars_hemispheres":hem_list}) 

    # Close the browser after scraping
    browser.quit()
    print(mars_data_dict)
    # Return results
    return mars_data_dict
