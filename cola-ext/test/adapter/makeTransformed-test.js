(function(buster, when_, delay, makeTransformed) {
  var addOne, addOneWithInverse, assert, createFakeAdapter, fail, makePromised, refute, resolved;
  createFakeAdapter = function(data) {
    data = data || [];
    return {
      add: function(item) {},
      remove: function(item) {},
      update: function(item) {},
      clear: function() {},
      forEach: function(f) {
        var i, len;
        i = 0;
        len = data.length;
        while (i < len) {
          f(data[i]);
          i++;
        }
      },
      getOptions: function() {}
    };
  };
  resolved = function(val) {
    return delay(val, 0);
  };
  makePromised = function(f) {
    var promised;
    promised = function(x) {
      return resolved(f(x));
    };
    if (f.inverse) {
      promised.inverse = function(x) {
        return resolved(f.inverse(x));
      };
    }
    return promised;
  };
  addOne = function(x) {
    return x + 1;
  };
  addOneWithInverse = function(x) {
    return addOne(x);
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  addOneWithInverse.inverse = function(x) {
    return x - 1;
  };
  buster.testCase('adapter/makeTransformed', {
    'should throw if no transform provided': function() {
      assert.exception(function() {
        makeTransformed(createFakeAdapter());
      });
    },
    'should not modify original adapter': function() {
      var adapter, originals, p;
      adapter = void 0;
      p = void 0;
      originals = void 0;
      originals = {};
      adapter = createFakeAdapter();
      for (p in adapter) {
        originals[p] = adapter[p];
      }
      makeTransformed(adapter, addOneWithInverse);
      for (p in adapter) {
        assert.same(adapter[p], originals[p]);
      }
    },
    'should preserve original comparator': function() {
      var adapter, comparator, transformed;
      comparator = function() {};
      adapter = void 0;
      transformed = void 0;
      adapter = createFakeAdapter();
      adapter.comparator = comparator;
      transformed = makeTransformed(adapter, addOneWithInverse);
      assert.same(transformed.comparator, comparator);
    },
    'should preserve original identifier': function() {
      var adapter, identifier, transformed;
      identifier = function() {};
      adapter = void 0;
      transformed = void 0;
      adapter = createFakeAdapter();
      adapter.identifier = identifier;
      transformed = makeTransformed(adapter, addOneWithInverse);
      assert.same(transformed.identifier, identifier);
    },
    getOptions: {
      'should return original adapter options': function() {
        var adapter, options, transformed;
        adapter = void 0;
        transformed = void 0;
        options = void 0;
        options = {};
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, addOneWithInverse);
        adapter.getOptions.returns(options);
        assert.same(transformed.getOptions(), options);
      }
    },
    forEach: {
      'should delegate with transformed value': function() {
        var adapter, lambda, transformed;
        adapter = void 0;
        transformed = void 0;
        lambda = void 0;
        adapter = createFakeAdapter([1]);
        transformed = makeTransformed(adapter, addOne);
        lambda = this.spy();
        transformed.forEach(lambda);
        assert.calledOnceWith(lambda, 2);
      },
      'should allow promised transforms': function(done) {
        var adapter, lambda, results, transformed;
        adapter = void 0;
        transformed = void 0;
        lambda = void 0;
        results = void 0;
        adapter = createFakeAdapter([1, 2, 3]);
        transformed = makeTransformed(adapter, makePromised(addOne));
        results = [];
        lambda = function(val) {
          results.push(val);
        };
        when_(transformed.forEach(lambda), function() {
          assert.equals(results, [2, 3, 4]);
        }, fail).then(done, done);
      }
    },
    add: {
      'should call original with inverse transformed item': function() {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, addOneWithInverse);
        transformed.add(1);
        assert.calledOnceWith(adapter.add, 0);
      },
      'should allow promised transforms': function(done) {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, makePromised(addOneWithInverse));
        when_(transformed.add(1), function() {
          assert.calledOnceWith(adapter.add, 0);
        }, fail).then(done, done);
      }
    },
    remove: {
      'should call original with inverse transformed item': function() {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, addOneWithInverse);
        transformed.remove(1);
        assert.calledOnceWith(adapter.remove, 0);
      },
      'should allow promised transforms': function(done) {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, makePromised(addOneWithInverse));
        when_(transformed.remove(1), function() {
          assert.calledOnceWith(adapter.remove, 0);
        }, fail).then(done, done);
      }
    },
    update: {
      'should call original with inverse transformed item': function() {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, addOneWithInverse);
        transformed.update(1);
        assert.calledOnceWith(adapter.update, 0);
      },
      'should allow promised transforms': function(done) {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, makePromised(addOneWithInverse));
        when_(transformed.update(1), function() {
          assert.calledOnceWith(adapter.update, 0);
        }, fail).then(done, done);
      }
    },
    clear: {
      'should call original clear': function() {
        var adapter, transformed;
        adapter = void 0;
        transformed = void 0;
        adapter = this.stub(createFakeAdapter());
        transformed = makeTransformed(adapter, addOneWithInverse);
        transformed.clear();
        assert.calledOnce(adapter.clear);
      }
    }
  });
})(require('buster'), require('when'), require('when/delay'), require('../../adapter/makeTransformed'));
