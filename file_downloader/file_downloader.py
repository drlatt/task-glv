import requests
from awsauth import S3Auth
import sys
import argparse
import boto3
import botocore
import multiprocessing
import os

from multiprocessing import Pool


# create flags to parse command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("s_url", help="provide an s3 download url")
parser.add_argument("h_url", help="provide an http download url")
args = parser.parse_args()


s3_url = args.s_url
http_url = args.h_url


# function to accept s3 url and download required file
def get_s3_file():
    parts = s3_url.split('/')
    
    # retrieve bucket name and key from url
    BUCKET_NAME = parts[2] 
    KEY = s3_url.split('/')[-1]

    s3 = boto3.resource('s3')

    # attempt to download s3 file and output errors if unsuccessful
    try:
        s3.Bucket(BUCKET_NAME).download_file(KEY, '{}'.format(KEY))
        print("Downloading {}".format(KEY))
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print("The object does not exist.")
        else:
            print("something went wrong...", e)


# function to accept http url and download required file 
def get_http_file():
    file_name = http_url.split('/')[-1]

    # attempt to download required file and output errors if unsuccessful
    try:
        r = requests.get(http_url, stream = True)
        r.raise_for_status()
        print("Downloading {}".format(file_name))
        with open(file_name, 'wb') as f:
    
            for chunk in r.iter_content(chunk_size=1024*1024):

                if chunk:
                    f.write(chunk)
    except requests.exceptions.HTTPError as errh:
        print("An HTTP error occured:", errh)
    except requests.exceptions.ConnectionError as errc:
        print ("A connection error occured:",errc)
    except requests.exceptions.Timeout as errt:
        print ("A timeout error occured:",errt)
    except requests.exceptions.RequestException as erre:
        print ("An error occured",erre)


def run_process(process):                                                             
    process


        

if __name__ == '__main__':
    # number_of_workers = 10
    # with Pool(number_of_workers) as pool:
    #     pool.starmap(get_http_file, get_s3_file)

    processes = (get_http_file, get_s3_file)
    pool = Pool(processes=10)
    pool.map(run_process, processes)


    # get_s3_file()    
    # # get_http_file()
    


