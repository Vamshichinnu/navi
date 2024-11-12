from flask import Flask, request, jsonify
import jinja2
import os
import subprocess

app = Flask(__name__)

@app.route('/setup', methods=['POST'])
def setup_pg_replication():
    data = request.json
    terraform_vars = {
        "instance_type": data["instance_type"],
        "pg_version": data["pg_version"],
        "max_connections": data["max_connections"],
        "shared_buffers": data["shared_buffers"],
        "num_replicas": data["num_replicas"],
    }

    # Render Terraform template
    template_loader = jinja2.FileSystemLoader(searchpath="./templates")
    template_env = jinja2.Environment(loader=template_loader)
    template_file = "main.tf.j2"
    template = template_env.get_template(template_file)
    rendered_content = template.render(terraform_vars)

    with open("generated_main.tf", "w") as tf_file:
        tf_file.write(rendered_content)

    # Initialize and apply Terraform
    os.system("terraform init")
    os.system("terraform apply -auto-approve")

    # Run Ansible playbooks
    os.system("ansible-playbook -i inventory setup_pg.yml")

    return jsonify({"message": "PostgreSQL primary-read-replica setup completed"}), 200

if __name__ == '__main__':
    app.run(debug=True)
