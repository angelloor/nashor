import multer from 'multer';

const _storageAvatar = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, './');
	},
	filename: function (req, file, cb) {
		cb(null, file.fieldname + '.jpg');
	},
});

const _storageLogo = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, './');
	},
	filename: function (req, file, cb) {
		cb(null, file.fieldname + '.png');
	},
});

export const uploadAvatar = multer({ storage: _storageAvatar });
export const uploadLogo = multer({ storage: _storageLogo });
