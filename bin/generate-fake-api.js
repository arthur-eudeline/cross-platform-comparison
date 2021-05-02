const fs = require('fs');
const path = require('path');
const { get } = require('axios');
const Config = require('../config.js');

let urlCache = [];

async function getRandomImageURL() {
  if (urlCache.length === 0) {
    const response = await get(
      'https://api.unsplash.com/photos/random',
      {
        params: {
          count: 30,
        },
        headers: {
          'Authorization': `Client-ID ${Config.unsplash.accessKey}`
        }
      }
    );

    response.data.forEach(imageData => urlCache.push(imageData['urls']['small']));
    console.log('Fetched 30 images');
  }

  return urlCache.pop();
}

async function main() {
  const initialDataPath = path.resolve(__dirname, '..', 'fake-api', 'sources', 'initial-data.json');
  const initialData = require(initialDataPath);

  const dataWImages = [];
  const initialDataWImagesPath = path.resolve(__dirname, '..', 'fake-api', 'sources', 'initial-data-with-images.json');
  if (process.argv.includes('--skip-cache') || fs.existsSync(initialDataWImagesPath) !== true) {
    for (let data of initialData) {
      data['image'] = await getRandomImageURL();
      dataWImages.push(data);
      console.log(`Image URL found : ${dataWImages.length}/${initialData.length}`);
    }

    fs.writeFileSync(initialDataWImagesPath, JSON.stringify(dataWImages), 'utf-8');
  } else {
    dataWImages.push(...require(initialDataWImagesPath));
  }

  const apiPath = path.resolve(path.resolve(__dirname, '..', 'fake-api', 'api-'));
  const splitByNumber = 10;
  let fileCounter = 0;
  let batchData = [];
  for (let i = 0; i < dataWImages.length; i++) {
    batchData.push(dataWImages[i]);
    if (i % splitByNumber === 0 && i !== 0) {
      fileCounter++;
      fs.writeFileSync(apiPath + fileCounter + ".json", JSON.stringify(batchData, null, 2), 'utf-8');
      batchData = [];
      console.log(`${apiPath + fileCounter + ".json"} created`);
    }
  }
}

main().then();
