const _ = require('lodash');
const { ClassModel } = require('../models');

const pick = ({object, keys}) => _.pick(object, keys);

const generateRandomCode = (length = 8) => {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let code = '';
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length);
    code += characters[randomIndex];
  }
  return code;
};

const createUniqueInviteCode = async () => {
  let isUnique = false;
  let inviteCode;

  while (!isUnique) {
    inviteCode = generateRandomCode();
    const existingGroup = await ClassModel.findOne({ where: { code_invite: inviteCode } });
    if (!existingGroup) {
      isUnique = true;
    }
  }

  return inviteCode;
};


module.exports = {
  pick,
  createUniqueInviteCode
};
