import axios from 'axios';

const postOkrTree = async (tree, owner_id) => {
  tree.goals = JSON.parse(JSON.stringify(tree.children));
  tree.owner_id = owner_id;

  const newTree = JSON.stringify(tree).replace(/"children":/g, '"key_results_attributes":');

  try {
    const response = await axios
      .post(`${process.env.REACT_APP_API_URL}/goals/batch`, JSON.parse(newTree))
    console.log(response);

    tree.goal_id = response.data.data[0].id

    return tree
  } catch (error) {
    console.error(error);
  }


};

export default postOkrTree;
