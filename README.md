# Elasticsearch Aggregation Tagging AKA "Agg Tags"
We can use Elasticsearch aggregations to get summaries and statistics on our product data, such as the most common category for a given query. Using product titles as queries, we can use Elasticsearch to assign categories to products that don't have categories or have messy categories. 

## Aggregations
Every aggregation is simply a combination of one or more buckets and zero or more metrics. 
* Buckets - Collections of documents that meet a criterion
* Metrics - Statistics calculated on the documents in a bucket

Without a metric, the aggregation will return an approximate document count for values in the bucket. 

For example, the category bucket would contain the values Electronics, Laptops, and Chargers. 

## Use Cases
Augmenting the product catalog with agg tags should enable search to return relevant results for broad searches, e.g. movies, as opposed to returning products with the word movies in their titles. 

A controlled vocabulary of product tags across stores could enable additional navigational features within the browsing experience e.g. after returning search results, give the user the ability to filter to a specific category or back out a search to a broader category. 

A controlled vocabulary when combined with user events data will enable a robust data set of user preferences for personalization.


## Build and Deploy

0. Define environment variables
```
export PROJECT="production"
export ZONE="us-central1-a" 
export CLUSTER="my_cluster" 
export COMPONENT="my_component" 
export GCS_DIR="gs://categories" 
export VERSION=1
```

```
gcloud config set project $PROJECT 
gcloud config set compute/zone $ZONE 
gcloud config set container/cluster $CLUSTER 
gcloud container clusters get-credentials $CLUSTER
```

1. Build docker image in logstash folder
```
docker build  -f docker/agg-tags-Dockerfile --tag us.gcr.io/$PROJECT/logstash-agg-tags:6.2.4-$VERSION .
```
2. Test docker image
```
docker run --rm --entrypoint bash -it us.gcr.io/production/honey-logstash-agg-tags:6.2.4-$VERSION
```
3. Push image to Docker registry
```
gcloud docker -- push us.gcr.io/$PROJECT/logstash-agg-tags:6.2.4-$VERSION
```

4. apply kubernetes
```
envsubst < yml/es-agg-tags-logstash.yml | kubectl apply -f -
