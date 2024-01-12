import algoliasearch from 'algoliasearch';
const client = algoliasearch(
  process.env.ALGOLIA_APP_ID || '',
  process.env.ALGOLIA_API_KEY || ''
);

const index = client.initIndex('Entities');

index.setSettings({
  searchableAttributes: [
    'arabicName',
    'englishName',
    'arabicDescription',
    'englishDescription',
    'Address.arabicName',
    'Address.englishName',
    'Address.AddressTage.tag.arabicName',
    'Address.AddressTage.tag.englishName',
    'EntityCategory.category.arabicName',
    'EntityCategory.category.englishName',
    'EntityTag.tag.arabicName',
    'EntityTag.tag.englishName',
    'city.arabicName',
    'city.englishName',
  ],
  attributesForFaceting: [
    'status',
    'type',
    'Address.AddressTage.tag.arabicName',
    'Address.AddressTage.tag.englishName',
    'EntityCategory.category.arabicName',
    'EntityCategory.category.englishName',
    'EntityTag.tag.arabicName',
    'EntityTag.tag.englishName',
    'city.arabicName',
    'city.englishName',
  ],
});

export default index;
