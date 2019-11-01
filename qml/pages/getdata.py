#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pyotherside
import sys
import datetime
import string
import urllib
import urllib.parse
from urllib.parse import quote
import urllib.request
from urllib.request import urlopen
import json


def unix_time(dt):
    epoch = datetime.datetime.utcfromtimestamp(0)
    return int((dt - epoch).total_seconds())

def allFood(coop_resta_id):
    req = urllib.request.Request(url='https://themachine.jeremystucki.com/coop/api/v2/locations/' + coop_resta_id + '/menus/today', method='GET')
    res = urllib.request.urlopen(req)
    res_body = res.read()
    j = json.loads(res_body.decode("utf-8"))
    results = j['results']

    pyotherside.send('loadingCircle', "gelodet")
    return results



def oneFood(food, price, coop_resta_id):
    req = urllib.request.Request(url='https://themachine.jeremystucki.com/coop/api/v2/locations/' + coop_resta_id + '/menus/today', method='GET')
    res = urllib.request.urlopen(req)
    res_body = res.read()
    j = json.loads(res_body.decode("utf-8"))
    results = j['results']

    for menu in results:
        if menu['title'] == food:
            if price == menu['price']:
                pyotherside.send('oneFood-title', menu['title'])
                pyotherside.send('oneFood-price', menu['price'])

                for item in menu['menu']:
                    pyotherside.send('oneFood-menu', '\n'.join(menu['menu']))
        else:
            pyotherside.send('oneFood-title', food)
            pyotherside.send('oneFood-price', price)

def info():
    current_day = unix_time(datetime.datetime.combine(datetime.datetime.now().date(), datetime.time()))
    timestamp = str(current_day)
    pyotherside.send('timestamp', timestamp)

def getAllLocation(location_in):
    req = urllib.request.Request(url='https://themachine.jeremystucki.com/coop/api/v2/locations', method='GET')
    res = urllib.request.urlopen(req)
    res_body = res.read()
    j = json.loads(res_body.decode("utf-8"))
    results = j['results']

    for location in results:
        if location['name'] == location_in:
            coop_resta_id = location['id']
            coop_resta_id = str(coop_resta_id)
            pyotherside.send('setLocationID', coop_resta_id)
            print("Coop Location ID: " + coop_resta_id)

