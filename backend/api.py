from flask import Flask, request
import os
import requests
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)
try:
	URL_TOKEN = 'https://api.intra.42.fr/oauth/token'
	BASE_URL = 'https://api.intra.42.fr/v2/'

	UUID = os.getenv('UUID')
	SECRET = os.getenv('SECRET')

	query_params = f'?grant_type=client_credentials&client_id={UUID}&client_secret={SECRET}';
	response = requests.post(URL_TOKEN + query_params)
	TOKEN = response.json()['access_token']
except Exception as e:
	print('Error : ', e)
	exit()

@app.route('/api/data', methods=['GET'])
def get_data():
	try:
		args = request.args['login']
		user_response = requests.get(BASE_URL + f'users/{args}', headers={'Authorization': 'Bearer ' + TOKEN})
		data = {
			'login' : user_response.json()['login'],
			'email' : user_response.json()['email'],
			'correction_point' : user_response.json()['correction_point'],
			'wallet' : user_response.json()['wallet'],
		}
		skills = {}
		level = {}
		for i in user_response.json()['cursus_users']:
			level[i['cursus']['name']] = f"{str(i['level']).split('.')[0]} - {str(i['level']).split('.')[1]}%"
			new_skills = {}
			for j in i['skills']:
				new_skills[j['name']] = j['level']
			skills[i['cursus']['name']] = new_skills
		data["cursus"] = level
		data["skill"] = skills
		# print(level)
		project_respect = requests.get(BASE_URL + f'users/{args}/projects_users?page[size]=100', headers={'Authorization': 'Bearer ' + TOKEN})
		project = {}
		for i in project_respect.json():
			match i['validated?']:
				case True: project[i['project']['name']] = 'Validated'
				case False: project[i['project']['name']] = 'Failed'
				case _: project[i['project']['name']] = 'In Progress'
		data['project'] = project
	except Exception as e:
		print('Error : ', e)
		return
	return data

if __name__ == '__main__':
    app.run(debug=True);
	# data = get_data();
	# print(data);