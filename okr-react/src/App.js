import "./App.css";

import React, { Component } from "react";
import initialTree from "./initialTree";
import { ContextMenuTrigger } from "react-contextmenu";
import _ from "lodash";
import deepdash from "deepdash";
import postOkrTree from "./request/Middleware";
import OkrTree from "./treeComponents/OkrTree";
import NodeToolbar from "./treeComponents/NodeToolbar";

import "./styles.css";
import "react-ui-tree/dist/react-ui-tree.css";
import "./theme.css";
import "./react-contextmenu.css";

// add deepdash to lodash
deepdash(_);

const FOLDER_ID = "folder";
const CHILDREN_ID = "children";

const initialState = {
  active: null,
  tree: {
    ...initialTree,
  },
  collapsed: false, // start with unmodified tree
};
class App extends Component {
  state = initialState;

  deleteItem = (tree, id) => {
    function getNode(node, i) {
      if (node.id === id) {
        index = i;
        return true;
      }
      if (Array.isArray(node.children) && node.children.some(getNode)) {
        if (~index) {
          node.children.splice(index, 1);
          index = -1;
        }
        return true;
      }
    }

    let index = -1;
    [tree].some(getNode);
    this.setState({
      tree: tree,
    });
  };

  newItemName = (itemType) => {
    return itemType === FOLDER_ID ? "New Goal" : "New Key Result";
  }

  newItem = (itemType) => {
    const item =
      itemType === FOLDER_ID
        ? {
          id: `root-${Date.now()}`,
          title: this.newItemName(itemType),
          children: [],
          collapsed: false,
        }
        : {
          id: `${Date.now()}`,
          leaf: true,
          title: this.newItemName(itemType),
        };
    return item;
  };

  addItem = (itemType, active) => {
    const { tree } = this.state;
    const newItem = this.newItem(itemType);

    const newTree = _.mapDeep(tree, (item) => {
      const cloneItem = Object.assign({}, item);
      if (cloneItem) {
        if (cloneItem.id === active.id && cloneItem.children) {
          cloneItem.children.push(newItem);
        }
      }
      return cloneItem;
    });

    this.setState({ ...newTree });
  };

  renderNode = (node) => (
    <ContextMenuTrigger
      id="FILE_CONTEXT_MENU"
      key={node.id}
      name={node.id}
      collect={() => this.props}
      holdToDisplay={-1}
      onItemClick={this.handleContextClick}
    >
      {
        <NodeToolbar
          node={node}
          isFolder={node.hasOwnProperty(CHILDREN_ID)}
          isRoot={node.id === "root-0"}
          caption={node.title}
          addItem={this.addItem}
        />
      }
    </ContextMenuTrigger>
  );

  handleContextClick = (e, { action, target }) => {
    const { tree } = this.state;
    const id = target.id;

    if (id == null)
      return;

    switch (action) {
      case "rename":
        const renameObj = _.findDeep(tree, (item) => item.id === id, {
          childrenPath: CHILDREN_ID,
        });
        const response = prompt("Please rename", renameObj.value.title);

        if (response === "") {
          return;
        }
        renameObj.value.title = response;
        this.setState(
          _.mapDeep(
            tree,
            (item) =>
              item.id === id
                ? {
                  ...item,
                  ...renameObj.value,
                }
                : item,
            { childrenPath: CHILDREN_ID }
          )
        );
        break;
      case "delete":
        this.deleteItem(tree, id);
        this.setState({
          tree,
        });
        break;
      default:
    }
  };

  handleChange = (tree) => {
    this.setState({
      tree: tree,
    });
  };

  save = () => {
    postOkrTree(this.state.tree, 1);
  };

  render() {
    return (
      <OkrTree
        tree={this.state.tree}
        handleChange={this.handleChange}
        renderNode={this.renderNode}
        save={this.save}
        handleContextClick={this.handleContextClick}
      />
    );
  }
}

export default App;
