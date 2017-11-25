def test_reconfigure(host):
    assert host.command('sudo gitlab-ctl reconfigure').rc == 0
    assert host.command('sudo gitlab-ctl restart').rc == 0
    assert host.command('sudo gitlab-ctl status').rc == 0


def test_socket(host):
    assert host.socket('tcp://0.0.0.0:80').is_listening
