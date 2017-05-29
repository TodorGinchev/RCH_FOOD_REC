#!/usr/bin/env python

# --------------------------------------------------------
# Faster R-CNN
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# --------------------------------------------------------

"""
Demo script showing detections in sample images.

See README.md for installation instructions before running.
"""
import _init_paths
from fast_rcnn.config import cfg
from fast_rcnn.test import im_detect
from fast_rcnn.nms_wrapper import nms
from utils.timer import Timer
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import caffe, os, sys, cv2
import argparse
import os
import pandas as pd
import pdb
import numpy as np
data_category = pd.read_csv('./lib/datasets/category.txt', '\t')

CLASSES = tuple(['background'] + list(data_category.name.str.lower()))

NETS = {'vgg16': ('VGG16',
                  'VGG16_faster_rcnn_final.caffemodel'),
        'zf': ('ZF',
                  'ZF_faster_rcnn_final.caffemodel')}



def detect_object(image_name, net, thres_value):
    """Detect object classes in an image using pre-computed object proposals."""

    # Load the demo image
    # im_file = os.path.join(cfg.DATA_DIR, 'demo', image_name)
    im = cv2.imread(image_name)
    # Detect all object classes and regress object bounds
    timer = Timer()
    timer.tic()
    scores, boxes = im_detect(net, im)
    timer.toc()
    print ('Detection took {:.3f}s for '
           '{:d} object proposals').format(timer.total_time, boxes.shape[0])

    # Visualize detections for each class
    CONF_THRESH = thres_value
    NMS_THRESH = 0.3
    detected_obj = list()
    pclass = list()
    pscore = list()
    for cls_ind, cls in enumerate(CLASSES[1:]):
        cls_ind += 1 # because we skipped background
        cls_boxes = boxes[:, 4*cls_ind:4*(cls_ind + 1)]
        cls_scores = scores[:, cls_ind]
        dets = np.hstack((cls_boxes,
                          cls_scores[:, np.newaxis])).astype(np.float32)
        keep = nms(dets, NMS_THRESH)
        dets = dets[keep, :]

        inds = np.where(dets[:, -1] >= CONF_THRESH)[0]
        if len(inds) > 0:
            bbox = dets[inds, :4]
            score = dets[inds, -1]
            pclass.append(cls)
            pscore.append( score.tolist()[0])
     
    return pclass, pscore
    
    
def parse_args():
    parser = argparse.ArgumentParser(description='Faster R-CNN demo')
    parser.add_argument('--gpu', dest='gpu_id', help='GPU device id to use [0]', default=0, type=int)
    parser.add_argument('--cpu', dest='cpu_mode', help='Use CPU mode (overrides --gpu)', action='store_true')
    parser.add_argument('--net', dest='demo_net', help='Network to use [vgg16]', choices=NETS.keys(), default='zf')
    #parser.add_argument('--imgpath', dest = 'imgpath')
       
    args = parser.parse_args()
    return args 

def load_model():
    
    cfg.TEST.HAS_RPN = True  # Use RPN for proposals

    # args = parse_args()
    prototxt = "./models/food_rec/test.prototxt"
    caffemodel ='./output/food_rec/train1/zf_faster_rcnn_iter_30000.caffemodel'
    # caffemodel = '/home/shishir/foodrec/py-faster-rcnn/output/food_rec/train/zf_faster_rcnn_iter_40000.caffemodel'
    if not os.path.isfile(caffemodel):
        raise IOError(('{:s} not found.\nDid you run ./data/script/'
                       'fetch_faster_rcnn_models.sh?').format(caffemodel))

    caffe.set_mode_gpu()

    caffe.set_device(0)
    #cfg.GPU_ID = args.gpu_id
    net = caffe.Net(prototxt, caffemodel, caffe.TEST)
    
    print '\n\nLoaded network {:s}'.format(caffemodel)
    return net

def reco_main(im_name, net):

    # Warmup on a dummy image
    im = 128 * np.ones((300, 500, 3), dtype=np.uint8)
    for i in xrange(2):
        _, _= im_detect(net, im)

    return detect_object(im_name, net, thres_value)

if __name__ == '__main__':
    net = load_model()
    test_file = './data/food_rec/ImageSets/validation.txt'
    result = dict()

    for thres_value in np.arange(0,1,0.1):
        pred_bool = list()
        pred_dict = dict() 
        with open(test_file) as fp:
            for line in fp:
                actual_class = CLASSES[int(line.strip().split('_')[0])]
                img_path = './data/food_rec/JPEGImages/' + line.strip() + '.jpg'
                pclass, pscore = detect_object(img_path, net, thres_value)
                pred_dict[line.strip()] = (actual_class, pclass, pscore)
                pred_bool.append(actual_class in pclass)
                print actual_class, pclass, pscore
            
            result[thres_value] = (pred_bool, pred_dict)
    pdb.set_trace()
            
