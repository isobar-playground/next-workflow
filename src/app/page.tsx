import {Attributes as PageNode} from "@/types/schemas/node--page";
import {Attributes as ArticleNode} from "@/types/schemas/node--article";
import {Drupal, DrupalJsonApiParams} from "@/lib/drupal";
import Link from "next/link";

const params = DrupalJsonApiParams();

export default async function Home() {
    const node = await Drupal.getObject({
        objectName: 'node--page',
        id: process.env.FRONT_PAGE_NODE_UUID,
        params: params
    }) as PageNode;

    const articles = await Drupal.getObject({
        objectName: 'node--article',
        params,
    }) as Array<ArticleNode>

    return (
        <>
            <h1>{node.title}</h1>
            <p>{node.body?.value}</p>
            <ul>
                {articles.map((item) => {
                    return (
                        <li key={item.path?.alias}><Link
                            href={item.path?.alias || `/node/${item.drupal_internal__nid}`}>{item.title}</Link></li>
                    )
                })}
            </ul>
        </>
    )
}
