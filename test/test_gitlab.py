def test_reconfigure(host):
    reconfigure = host.run('gitlab-ctl reconfigure')
    assert reconfigure.rc == 0

def test_service(host):
    service = host.run('gitlab-ctl status')
    assert service.rc == 0
