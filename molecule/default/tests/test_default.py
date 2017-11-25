import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_command(Host):
    assert Host.command('sudo gitlab-ctl reconfigure').rc == 0
    assert Host.command('sudo gitlab-ctl restart').rc == 0
    assert Host.command('sudo gitlab-ctl status').rc == 0


def test_socket(Host):
    assert Host.socket('tcp://0.0.0.0:80').is_listening
