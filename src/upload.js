const program = require('commander');

const { logError, putResource } = require('./helpers');

const BASE_DIR = '../output';
const DEFAULT_URL = 'localhost:8080/r4';

let serverUrl;
program
    .usage('<host>')
    .arguments('<host>')
    .action(host => serverUrl = host)
    .parse(process.argv);
serverUrl = serverUrl || DEFAULT_URL;
if (!serverUrl.startsWith('http')) {
    serverUrl = `http://${serverUrl}`;
}

main(serverUrl);

/**
 * Load the implementation guide from JSON file.
 */
function getImplementationGuide() {
    return require(`${BASE_DIR}/ImplementationGuide-cms-del.json`);
}

/**
 * For each resources in the IG, try to load the corresponding JSON file.
 * @param {*} ig
 */
function getResources(ig) {
    const output = [];
    for (const resource of ig.definition.resource) {
        const [type, ident] = resource.reference.reference.split('/', 2);
        const fileName = `${BASE_DIR}/${type.toLowerCase()}-${ident}.json`;
        output.push(require(fileName));
    }
    return output;
}

/**
 * Upload the given resource to the given URL.
 *
 * @param {String} url
 * @param {*} resource
 */
async function uploadResource(url, resource) {
    // The IG generated doesn't seem to work right. This fixes it.
    if (resource.resourceType === 'ImplementationGuide') {
        delete resource.extension;
        delete resource.definition.parameter;
        resource.text = {
            status: 'generated',
            div: '<div xmlns="http://www.w3.org/1999/xhtml">FHIR Implementation Guide for CMS Data Element Library</div>',
        };
    }

    const response = await putResource(url, resource);
    return response;
}

/**
 * Run the main process.
 * @param {String} serverUrl
 */
async function main(serverUrl) {
    const ig = getImplementationGuide();

    const resources = getResources(ig);

    for (const resource of resources) {
        try {
            await uploadResource(serverUrl, resource);
        } catch (error) {
            logError(error);
        }
    }

    await uploadResource(serverUrl, ig);
}
