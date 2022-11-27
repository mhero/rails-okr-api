import axios from 'axios';

const postOkrTree = (tree, owner_id) => {
  tree.goals = JSON.parse(JSON.stringify(tree.children));
  tree.owner_id = owner_id;

  const json = JSON.stringify(tree),
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
