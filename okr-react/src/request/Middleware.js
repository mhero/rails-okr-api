import axios from 'axios';

const renameKeys = (obj, oldKey, newKey) => {
  if (obj === null || typeof obj !== 'object') {
    return obj;
  }

  return Array.isArray(obj)
    ? obj.map(item => renameKeys(item, oldKey, newKey))
    : Object.fromEntries(
      Object.entries(obj).map(([key, value]) => [
        key === oldKey ? newKey : key,
        renameKeys(value, oldKey, newKey)
      ])
    );
}

const postOkrTree = async (tree, owner_id) => {
  tree.goals = JSON.parse(JSON.stringify(tree.children));
  tree.owner_id = owner_id;

  const newTree = renameKeys(tree, 'children', 'key_results_attributes');

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
