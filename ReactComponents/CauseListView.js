'use strict';

import React from 'react';

import {
  AppRegistry,
  ListView,
  StyleSheet,
  Text,
  Image,
  RefreshControl,
  TouchableHighlight,
  View
} from 'react-native';

var Style = require('./Style.js');
var Bridge = require('react-native').NativeModules.LDTReactBridge;
var NetworkErrorView = require('./NetworkErrorView.js');
var NetworkLoadingView = require('./NetworkLoadingView.js')

var CauseListView = React.createClass({
  getInitialState: function() {
    return {
      dataSource: new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2,
      }),
      isRefreshing: false,
      loaded: false,
      error: false,
    };
  },
  componentDidMount: function() {
    this.fetchData();
  },
  fetchData: function() {
    this.setState({
      error: false,
      loaded: false,
    });
    fetch(this.props.url)
      .then((response) => response.json())
      .catch((error) => this.catchError(error))
      .then((responseData) => {
        if (!responseData) {
          return;
        }
        this.setState({
          dataSource: this.state.dataSource.cloneWithRows(responseData.categories),
          loaded: true,
        });
      })
      
      .done();
  },
  catchError: function(error) {
    console.log("CauseListView.catchError");
    this.setState({
      error: error,
    });
  },
  render: function() {
    if (this.state.error) {
      return (
        <NetworkErrorView
          title="Actions aren't loading right now"
          retryHandler={this.fetchData}
          errorMessage={this.state.error.message}
        />);
    }
    if (!this.state.loaded) {
      return <NetworkLoadingView text="Loading actions..." />;
    }

    return (
      <ListView
        dataSource={this.state.dataSource}
        renderRow={this.renderRow}
        style={styles.listView}
        refreshControl={<RefreshControl
          onRefresh={this._onRefresh}
          refreshing={this.state.isRefreshing}
          tintColor="#CCC" />}
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
  _onPressRow(cause) {
    Bridge.pushCause(cause);
  },
  renderRow: function(cause) {
    var causeColorStyle = {backgroundColor: '#' + cause.hex};
    return (
      <TouchableHighlight onPress={() => this._onPressRow(cause)}>
        <View style={styles.row}>
          <View style={[styles.causeColor, causeColorStyle]} />
          <View style={[styles.contentContainer, styles.bordered]}>
            <View>
              <Text style={Style.textHeading}>{cause.title}</Text>
            </View>
          </View>
          <View style={[styles.arrowContainer, styles.bordered]}>
              <Image
                style={styles.arrowImage}
                source={require('image!Arrow')}
              />  
          </View>
        </View>
      </TouchableHighlight>
    );
  },
});

var styles = StyleSheet.create({
  listView: {
    backgroundColor: '#FFFFFF',
    paddingBottom: 10,
  },
  row: {
    backgroundColor: '#FFFFFF',
    flex: 1,
    flexDirection: 'row',
  },
  causeColor: {
    width: 8,
    backgroundColor: '#00FF00',
    height: 84,
  },
  bordered: {
    borderColor: '#EDEDED',
    borderTopWidth: 2,
    borderBottomWidth: 2,    
  },
  contentContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    paddingLeft: 8,
    height: 84,
  },
  arrowContainer: {
    width: 38,
    height: 84,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  arrowImage: {
    width: 12,
    height: 21,
  },
});

module.exports = CauseListView;
