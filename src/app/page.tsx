import {Attributes as PageNode} from "@/types/schemas/node--page";
import {Drupal, DrupalJsonApiParams} from "@/lib/drupal";

const params = DrupalJsonApiParams();

export default async function Home() {
    const node = await Drupal.getObject({
        objectName: 'node--page',
        id: process.env.FRONT_PAGE_NODE_UUID,
        params: params
    }) as PageNode;

    return (
        <>
            <h1>{node.title}</h1>
            <p>{node.body?.value}</p>
        </>
    )
}
