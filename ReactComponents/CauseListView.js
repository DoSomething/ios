'use strict';

import React, {
  AppRegistry,
  ActivityIndicatorIOS,
  ListView,
  Component,
  StyleSheet,
  Text,
  RefreshControl,
  TouchableHighlight,
  View
} from 'react-native';

var Helpers = require('./Helpers.js');
var CauseListViewController = require('react-native').NativeModules.LDTCauseListViewController;

var CauseListView = React.createClass({
  getInitialState: function() {
    return {
      dataSource: new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2,
      }),
      isRefreshing: false,
      loaded: false,
    };
  },
  componentDidMount: function() {
    this.fetchData();
  },
  fetchData: function() {
    fetch(this.props.url)
      .then((response) => response.json())
      .then((responseData) => {
        this.setState({
          // This will eventually turn into responseData.data once API is formatted correctly
          dataSource: this.state.dataSource.cloneWithRows(responseData),
          loaded: true,
        });
      })
      .done();
  },
  render: function() {
    if (!this.state.loaded) {
      return this.renderLoadingView();
    }

    return (
      <ListView
        dataSource={this.state.dataSource}
        renderRow={this.renderRow}
        style={styles.listView}
        refreshControl={
          <RefreshControl
            refreshing={this.state.isRefreshing}
            onRefresh={this._onRefresh}
            tintColor="#3932A9"
            colors={['#ff0000', '#00ff00', '#0000ff']}
            progressBackgroundColor="#ffff00"
          />
        }
      />
    );
  },
  _onRefresh: function () {
    this.setState({isRefreshing: true});
    setTimeout(() => {
      this.fetchData();
      this.setState({
        isRefreshing: false,
      });
    }, 1000);
  },
  renderLoadingView: function() {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicatorIOS animating={this.state.animating} style={[{height: 80}]} size="small" />
        <Text style={styles.text}>
          Loading causes...
        </Text>
      </View>
    );
  },
  _onPressCauseID(cause) {
    CauseListViewController.presentCauseWithCauseID(cause);
  },
  renderRow: function(cause) {
    // Will eventually change to id.
    var causeID = cause.tid;
    var causeColorStyle = {backgroundColor: Helpers.causeBackgroundColor(cause.name)};
    var subtitle = null;
    if (cause.description) {
      subtitle = cause.description.substr(0, 10);
    }
    return (
      <TouchableHighlight onPress={() => this._onPressCauseID(cause)}>
        <View style={styles.row}>
          <View style={[styles.causeColor, causeColorStyle]} />
          <View style={styles.content}>
            <View>
              <Text style={styles.title}>{cause.name}</Text>
              <Text style={styles.text}>{subtitle}</Text>
            </View>
          </View>
        </View>
      </TouchableHighlight>
    );
  },
});

var styles = React.StyleSheet.create({
  listView: {
    backgroundColor: '#FFFFFF',
    paddingBottom: 10,
  },
  loadingContainer: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#EEE',
  },
  text: {
    color: '#4A4A4A',
    fontFamily: 'Brandon Grotesque',
    fontSize: 12,
  },
  causeColor: {
    width: 8,
    backgroundColor: '#00FF00',
    height: 84,
  },
  content: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    paddingLeft: 8,
    borderColor: '#EDEDED',
    borderTopWidth: 2,
    borderBottomWidth: 2,
    height: 84,
  },
  row: {
    backgroundColor: '#FFFFFF',
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
  },
  title: {
    color: '4A4A4A',
    fontFamily: 'BrandonGrotesque-Bold',
    fontSize: 18,
  }
});

module.exports = CauseListView;
