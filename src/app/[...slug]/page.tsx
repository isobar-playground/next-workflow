import Link from "next/link";
import {Drupal, DrupalJsonApiParams} from "@/lib/drupal";
import {Attributes as Article} from "@/types/schemas/node--article";

const jsonApiParams = DrupalJsonApiParams();

export default async function Page({params}: any) {
    const path = `/` + params.slug.join('/')

    const content = await Drupal.getObjectByPath({
        objectName: 'node--article',
        path: path,
        params: jsonApiParams
    }) as Article

    return (
        <>
            <Link href="/">{"< Home"}</Link>
            <h1>{content.title}</h1>
            {content.body?.value}
        </>
    )
}
