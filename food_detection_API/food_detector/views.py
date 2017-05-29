from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import numpy as np
import urllib
import json
import cv2
import os
import sys
from detected_food_reco import reco_main

@csrf_exempt
def detect(request):
    data = {}

    img_path = request.POST.get('url', None)

    if img_path is None:
        data['error'] = 'No URL provided.'
   
    recommendation = reco_main(img_path)
    data.update(recommendation)

    return JsonResponse(data)
#def main():
#    print reco_main()
#if  __name__ == '__main__':
#    main()
