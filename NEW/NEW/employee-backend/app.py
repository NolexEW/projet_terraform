from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

employees = [
    {
        'id': 1,
        'firstName': 'Karim',
        'lastName': 'Benzema',
        'emailId': 'Benzema@gmail.com'
    },
    {
        'id': 2,
        'firstName': 'Leo',
        'lastName': 'Messi',
        'emailId': 'Messi@gmail.com'
    },
    {
        'id': 3,
        'firstName': 'Ronaldo',
        'lastName': 'Cristiano',
        'emailId': 'Cristiano@gmail.com'
    },
]

@app.route('/said/mikail', methods=['GET'])
def get_said():
    return "Happy Birthday Lenny :)"

@app.route('/api/v1/employees', methods=['GET', 'POST'])
def manage_employees():
    if request.method == 'GET':
        return jsonify(employees)

    if request.method == 'POST':
        employee = request.get_json()
        employee['id'] = employees[-1]['id'] + 1
        employees.append(employee)
        return jsonify(employee), 201

@app.route('/api/v1/employees/<int:employee_id>', methods=['GET', 'DELETE'])
def manage_employee(employee_id):
    employee = [employee for employee in employees if employee['id'] == employee_id]
    if len(employee) == 0:
        return jsonify({'error': 'employee not found'})

    if request.method == 'GET':
        return jsonify(employee[0])

    if request.method == 'DELETE':
        employees.remove(employee[0])
        return jsonify({'result': 'employee deleted'})

if __name__ == '__main__':
    app.run(debug=True, port=8081)
