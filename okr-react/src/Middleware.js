const axios = require("axios").default;

const clone = (obj) => Object.assign({}, obj);

const renameTopNode = (object, key, newKey) => {
  const clonedObj = clone(object);
  const targetKey = clonedObj[key];
  delete clonedObj[key];
  clonedObj[newKey] = targetKey;

  return clonedObj;
};

const postOkrTree = (tree) => {
  const topLevelRename = renameTopNode(tree, "children", "goals");

  const json = JSON.stringify(topLevelRename),
    newTree = json.replace(/"children":/g, '"key_results_attributes":');

  axios
    .post(`${process.env.REACT_APP_API_URL}/goals/batch`, JSON.parse(newTree))
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });
};

export default postOkrTree;
