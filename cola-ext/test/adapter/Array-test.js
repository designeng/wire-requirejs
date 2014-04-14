(function(buster, when_, delay, ArrayAdapter) {
  var assert, promiseFor, refute, undef;
  promiseFor = function(array) {
    return delay(array, 0);
  };
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  buster.testCase('adapter/Array', {
    canHandle: {
      'should return true for an Array': function() {
        assert(ArrayAdapter.canHandle([]));
      },
      'should return true for a promise': function() {
        assert(ArrayAdapter.canHandle(when_.defer().promise));
      },
      'should return false for a non-Array': function() {
        refute(ArrayAdapter.canHandle(null));
        refute(ArrayAdapter.canHandle(undef));
        refute(ArrayAdapter.canHandle(0));
        refute(ArrayAdapter.canHandle(true));
        refute(ArrayAdapter.canHandle({
          length: 1
        }));
      }
    },
    options: {
      'should be a provider by default': function() {
        var a;
        a = new ArrayAdapter([]);
        assert(a.provide);
      },
      'should allow overriding provide': function() {
        var a;
        a = new ArrayAdapter([], {
          provide: false
        });
        refute(a.provide);
      }
    },
    forEach: {
      'should iterate over all items': function() {
        var forEachSpy, src;
        src = void 0;
        forEachSpy = void 0;
        src = new ArrayAdapter([
          {
            id: 1
          }, {
            id: 2
          }
        ]);
        forEachSpy = this.spy();
        src.forEach(forEachSpy);
        assert.calledTwice(forEachSpy);
        assert.calledWith(forEachSpy, {
          id: 1
        });
        assert.calledWith(forEachSpy, {
          id: 2
        });
      },
      'should iterate over all promised items': function(done) {
        var forEachSpy, src;
        src = void 0;
        forEachSpy = void 0;
        src = new ArrayAdapter(promiseFor([
          {
            id: 1
          }, {
            id: 2
          }
        ]));
        forEachSpy = this.spy();
        src.forEach(forEachSpy).then(function() {
          assert.calledTwice(forEachSpy);
          assert.calledWith(forEachSpy, {
            id: 1
          });
          assert.calledWith(forEachSpy, {
            id: 2
          });
          done();
        });
      }
    },
    add: {
      'should add new items': function() {
        var pa, spy;
        pa = new ArrayAdapter([
          {
            id: 1
          }
        ]);
        pa.add({
          id: 2
        });
        spy = this.spy();
        pa.forEach(spy);
        assert.calledTwice(spy);
      },
      'should allow adding an item that already exists': function() {
        var pa, spy;
        pa = new ArrayAdapter([
          {
            id: 1
          }
        ]);
        spy = this.spy();
        pa.forEach(spy);
        assert.calledOnce(spy);
      },
      'promise-aware': {
        'should add new items': function(done) {
          var pa, spy;
          pa = void 0;
          spy = void 0;
          pa = new ArrayAdapter(promiseFor([
            {
              id: 1
            }
          ]));
          spy = this.spy();
          when_(pa.add({
            id: 2
          }), function() {
            return pa.forEach(spy);
          }).then(function() {
            assert.calledTwice(spy);
          }).then(done, done);
        },
        'should allow adding an item that already exists': function(done) {
          var pa, spy;
          pa = void 0;
          spy = void 0;
          pa = new ArrayAdapter(promiseFor([
            {
              id: 1
            }
          ]));
          spy = this.spy();
          when_(pa.add({
            id: 1
          }), function() {
            return pa.forEach(spy);
          }).then(function() {
            assert.calledOnce(spy);
          }).then(done, done);
        }
      }
    },
    remove: {
      'should remove items': function() {
        var pa, spy;
        pa = new ArrayAdapter([
          {
            id: 1
          }, {
            id: 2
          }
        ]);
        pa.remove({
          id: 1
        });
        spy = this.spy();
        pa.forEach(spy);
        assert.calledOnce(spy);
      },
      'should allow removing non-existent items': function() {
        var pa, spy;
        pa = new ArrayAdapter([]);
        spy = this.spy();
        pa.forEach(spy);
        refute.called(spy);
      },
      'promise-aware': {
        'should remove items': function(done) {
          var pa, spy;
          pa = void 0;
          spy = void 0;
          pa = new ArrayAdapter(promiseFor([
            {
              id: 1
            }, {
              id: 2
            }
          ]));
          spy = this.spy();
          when_(pa.remove({
            id: 2
          }), function() {
            return pa.forEach(spy);
          }).then(function() {
            assert.calledOnce(spy);
          }).then(done, done);
        },
        'should allow removing non-existent items': function(done) {
          var pa, spy;
          pa = void 0;
          spy = void 0;
          pa = new ArrayAdapter(promiseFor([]));
          spy = this.spy();
          when_(pa.remove({
            id: 2
          }), function() {
            return pa.forEach(spy);
          }).then(function() {
            refute.calledOnce(spy);
          }).then(done, done);
        }
      }
    },
    update: {
      'should update items': function() {
        var pa, spy;
        pa = new ArrayAdapter([
          {
            id: 1,
            success: false
          }
        ]);
        spy = this.spy();
        pa.update({
          id: 1,
          success: true
        });
        pa.forEach(spy);
        assert.calledOnceWith(spy, {
          id: 1,
          success: true
        });
      },
      'should ignore updates to non-existent items': function() {
        var pa, spy;
        pa = new ArrayAdapter([
          {
            id: 1,
            success: true
          }
        ]);
        spy = this.spy();
        pa.update({
          id: 2,
          success: false
        });
        pa.forEach(spy);
        assert.calledOnceWith(spy, {
          id: 1,
          success: true
        });
      },
      'promise-aware': {
        'should update items': function(done) {
          var expected, pa, spy;
          pa = void 0;
          spy = void 0;
          expected = void 0;
          pa = new ArrayAdapter(promiseFor([
            {
              id: 1,
              success: false
            }
          ]));
          spy = this.spy();
          expected = {
            id: 1,
            success: true
          };
          when_(pa.update(expected), function() {
            return pa.forEach(spy);
          }).then(function() {
            assert.calledOnceWith(spy, expected);
          }).then(done, done);
        },
        'should ignore updates to non-existent items': function(done) {
          var expected, pa, spy;
          pa = void 0;
          spy = void 0;
          expected = void 0;
          expected = {
            id: 1,
            success: true
          };
          pa = new ArrayAdapter(promiseFor([expected]));
          spy = this.spy();
          when_(pa.update({
            id: 2,
            success: false
          }), function() {
            return pa.forEach(spy);
          }).then(function() {
            assert.calledOnceWith(spy, expected);
          }).then(done, done);
        }
      }
    },
    clear: {
      'should remove all items': function() {
        var forEachSpy, src;
        src = void 0;
        forEachSpy = void 0;
        src = new ArrayAdapter([
          {
            id: 1
          }, {
            id: 2
          }
        ]);
        forEachSpy = this.spy();
        src.clear();
        src.forEach(forEachSpy);
        refute.called(forEachSpy);
      },
      'promise-aware': {
        'should remove all items': function(done) {
          var forEachSpy, src;
          src = void 0;
          forEachSpy = void 0;
          src = new ArrayAdapter(promiseFor([
            {
              id: 1
            }, {
              id: 2
            }
          ]));
          forEachSpy = this.spy();
          when_(src.clear(), function() {
            return src.forEach(forEachSpy);
          }).then(function() {
            refute.called(forEachSpy);
          }).then(done, done);
        }
      }
    }
  });
})(require('buster'), require('when'), require('when/delay'), require('../../adapter/Array'));
