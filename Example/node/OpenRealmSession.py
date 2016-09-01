from twisted.internet.defer import inlineCallbacks
from twisted.internet.task import LoopingCall
from autobahn.twisted.wamp import ApplicationSession

class OpenRealmSession(ApplicationSession):
    @inlineCallbacks
    def onJoin(self, details):
        def heartbeat():
            return self.publish(u'org.swamp.heartbeat', 'Heartbeat!')

        LoopingCall(heartbeat).start(1)

        def add(num1, num2):
            return num1 + num2

        yield self.register(add, u"org.swamp.add")

        def echo(param1, param2):
            return param1, param2

        yield self.register(echo, u"org.swamp.echo")
    