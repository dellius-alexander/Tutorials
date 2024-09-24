import os
import re
import base64
import subprocess as sp
import requests as req
from pandas import DataFrame
from getpass import getpass

# import kivy
# kivy.require('1.0.6') # replace with your current kivy version !
# from kivy.app import App
# from kivy.uix.label import Label


# TODO: setup GUI to get input and display table of results; 
# See kivy for GUI: https://kivy.org/doc/stable/
# TODO: install password store and configure client environment to use password store
# TODO: install docker credentials helper in password store


class registry(object):
    #####################################################################
    def __init__(self, raw_url=None or str,username=None or str,passenv=None or str,passwd=None or str) -> None:
        """
        ## Docker Private Registry Tool:

        Interact with your private docker registry using this tool.  

        - access registry
        - print contents of private registry

        #### Create 3 environmentals in on your system for 
        - the private registry url environment variable
        - the private registry username environment variable
        - the private registry password store token environment variable

        :param raw_url: the private registry url environment variable
        :param username: the private registry username environment variable
        :param passenv: the private registry password store token environment variable
        :param passwd: the base64 encoded password string
        """
        try:
            raw_url = os.environ[raw_url]
            username = os.environ[username]
            passenv = os.environ[passenv]
            # print('URL: {}\nUSER: {}\nPASSENV: {}\n'.format(raw_url,username,passenv))
            self.raw_url = raw_url
            self.username = username
            self.passenv = passenv
            self.passwd = passwd
            # print('password: {}'.format(passwd))
            # super().__init__()
        except OSError as err:
            print('\nTheir was an error in your environment variable; parameter 2. \n{}'.format(err))
        except Exception as err: # last line of defense
            print('\nAn exception has occured.\n{}'.format(err))

    #####################################################################    
    def get_registry(self,raw_url=None,username=None,passenv=None) -> DataFrame:
        """
        Gets the contents of your private container registry and organizes them into a table.

        This function uses "pass" as its password store. It takes your password store path to user password and accesses your password store securely.
        
        :param raw_url: the private registry url environment variable
        :param username: the private registry username environment variable
        :param passenv: the private registry password store token environment variable
        """
        tbl = []

        raw_url = self.raw_url if raw_url is None else os.environ[raw_url]
        username = self.username if username is None else os.environ[username]
        passenv = self.passenv if passenv is None else os.environ[passenv]
        try:
            ##############################################################
            url = raw_url if re.search('/v2', raw_url) else '{}/v2'.format(raw_url)
            # rauth = passenv if os.environ[passenv] is None else os.environ[passenv]
            rauth = passenv if re.search('docker-credential-helpers',passenv) else os.environ[passenv]
            # print('Docker Credential Token: {}\n'.format(rauth))
            # we are using a password store to access passwords on needed
            passwd = sp.check_output(["pass", rauth])
            passwd = passwd.decode("utf-8")
            # username = input("Enter Username: ")
            # passw = getpass("Enter Password: ")
            # print(passwd)
            uauth = (username,passwd)
            catelog = '{}/_catalog/'.format(url)
            # print(catelog)
            catelog = req.get(catelog, auth=uauth,timeout=(5, 10))   
            # print(catelog.json())
            for a in catelog.json()['repositories']:
                # print(a)
                item_details = '{0}/{1}/tags/list/'.format(url,a)
                rsp = req.get(item_details, auth=uauth)
                json_rsp = rsp.json()
                # print(json_rsp)
                tbl.append(json_rsp)
                # print('[{} => {}]'.format(json_rsp['name'], json_rsp['tags']))
            # print(tbl)
            df = DataFrame(data=tbl)
            print('\n{}\n'.format(df))
            return df
        except req.exceptions.TooManyRedirects as err:
            print('{}'.format(err))
        except req.exceptions.ConnectionError as err:
            print('\nSorry, unable to connect to {}.\n\n{}'.format(raw_url,err))     
        except req.exceptions.URLRequired as err:
            print('{}'.format(err))
        except req.exceptions.StreamConsumedError as err:
            print('{}'.format(err))
        except req.exceptions.ConnectTimeout as err:
            print('{}'.format(err))
        except req.exceptions.HTTPError as err:
            print('{}'.format(err))
        except req.exceptions.RequestException as err:
            print('{}'.format(err))
        except req.exceptions.Timeout as err:
            print('\nI\'m so sorry but the server request timed out...\n\n{}'.format(err))
        except OSError as err:
            print('\nTheir was an error in your environment variable; parameter 2. \n{}'.format(err))
        except KeyError as err:
            print(f'\nThe environment variable {err} does not match any found in our system.\n')
        except Exception as err: # last line of defense
            print('\nAn exception has occured.\n\n{}'.format(err))

    #####################################################################
#########################################################################
if __name__ == '__main__':
    # Create 3 environmentals in on your system for 
    # - the private registry url
    # - the private registry username
    # - the private registry password store token
    # Gets a table of your private registry objects
    url = 'PRIVATE_REGISTRY_URL'
    usr = 'PRIVATE_REGISTRY_USER'
    envpass = 'PRIVATE_REGISTRY_AUTH'
    reg = registry(url,usr,envpass)
    reg.get_registry()
